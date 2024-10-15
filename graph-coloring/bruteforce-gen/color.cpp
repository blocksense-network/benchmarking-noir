#include <algorithm>
#include <cstdint>
#include <future>
#include <iostream>
#include <memory>
#include <random>
#include <thread>
#include <vector>

using namespace std;

typedef vector<vector<bool>> Neighbors;
typedef vector<size_t> Coloring;

// Reads from stdin the number n and a square matrix of neighbors containing
// 1s and 0s.
Neighbors read_input() {
    uint64_t n;
    cin >> n;

    vector<vector<bool>> neighbors(n, vector<bool>(n, false));

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            bool x;
            cin >> x;
            neighbors[i][j] = x;
        }
    }

    return neighbors;
}

// Checks if with the given assignment of colors to nodes (coloring) the
// graph specified by the neighbors matrix is validly 3-colored.
bool check_coloring(const Neighbors &neighbors, const Coloring &coloring) {
    int n = neighbors.size();

    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            if (neighbors[i][j] && coloring[i] == coloring[j]) {
                return false;
            }
        }
    }
    return true;
}

// Updates the coloring to the next one following this pattern:
//
// before: 0, 1, 0
// after: 0, 1, 1
//
// before: 0, 1, 2
// after: 0, 2, 0
//
// before: 2, 2, 2
// after: 0, 0, 0
void next_coloring(Coloring &coloring) {
    int n = coloring.size();

    for (int i = n - 1; i >= 0; --i) {
        if (coloring[i] == 2) {
            coloring[i] = 0;
        } else {
            ++coloring[i];
            break;
        }
    }
}

Coloring generate_random_coloring(int n) {
    Coloring coloring;
    coloring.reserve(n);

    random_device rand_dev;
    mt19937 generator(rand_dev());
    uniform_int_distribution<int> distr1(0, 1);
    uniform_int_distribution<int> distr2(0, 2);

    coloring.push_back(0);

    int x = distr1(generator);
    coloring.push_back(x);

    for (int i = 2; i < n; ++i) {
        int x = distr2(generator);
        coloring.push_back(x);
    }

    return coloring;
}

// Finds a 3-coloring of the given graph by trying all possibilities. If there
// is no solution, returns false; true otherwise.
bool find_coloring(const Neighbors &neighbors, Coloring &result) {
    vector<future<bool>> solved_futures;
    vector<future<Coloring>> output_futures;
    vector<thread> threads;
    solved_futures.reserve(81);
    output_futures.reserve(81);
    threads.reserve(81);

    int n = result.size();
    vector<Coloring> starting_points;
    starting_points.reserve(81);
    starting_points.push_back(vector<size_t>(n));
    for (int a = 1; a < 81; ++a) {
        starting_points.push_back(generate_random_coloring(n));
    }

    sort(starting_points.begin(), starting_points.end());

    bool any_solved = false;

    // spawn 81 threads to do our dirty job
    for (int thread_id = 0; thread_id < 81; ++thread_id) {
        auto f = [&any_solved, thread_id, starting_points, &neighbors](
                     promise<bool> &&solved, promise<Coloring> &&output) {
            Coloring coloring = starting_points[thread_id];
            Coloring final_coloring = starting_points[(thread_id + 1) % 81];
            do {
                if (any_solved) {
                    solved.set_value(false);
                    break;
                }
                if (check_coloring(neighbors, coloring)) {
                    solved.set_value(true);
                    output.set_value(coloring);
                    any_solved = true;
                    return;
                }

                next_coloring(coloring);

                // starting from 0 1 2 every time, so if we reach _ 2 _, that
                // means we have exhausted all possibilities
                if (coloring[1] == 2 || coloring == final_coloring) {
                    // We have reached the next starting point; give up.
                    solved.set_value(false);
                    return;
                }
            } while (true);
        };
        promise<bool> solved;
        promise<Coloring> output;

        solved_futures.push_back(solved.get_future());
        output_futures.push_back(output.get_future());

        thread t(move(f), move(solved), move(output));
        threads.push_back(move(t));
    }

    for (auto &t : threads) {
        t.join();
    }

    for (int i = 0; i < solved_futures.size(); ++i) {
        if (solved_futures[i].get()) {
            result = output_futures[i].get();
            return true;
        }
    }
    return false;
}

void print_toml(const Neighbors &neighbors, const Coloring &coloring) {
    int n = neighbors.size();

    cout << "graph = [";
    for (int i = 0; i < n; ++i) {
        cout << "[";
        for (int j = 0; j < n; ++j) {
            cout << neighbors[i][j];
            if (j < n - 1) {
                cout << ", ";
            }
        }
        cout << "]";
        if (i < n - 1) {
            cout << ", ";
        }
    }
    cout << "]" << endl;
    cout << "colors = 3" << endl;
    cout << "coloring = [";

    for (int i = 0; i < n; ++i) {
        cout << "[" << i << ", " << coloring[i] << "]";
        if (i < n - 1) {
            cout << ", ";
        }
    }
    cout << "]" << endl;
}

// Optimal graph 3-coloring using brute-force.
int main() {
    auto neighbors = read_input();

    vector<size_t> coloring(neighbors.size(), 0);
    if (find_coloring(neighbors, coloring)) {
        print_toml(neighbors, coloring);
    } else {
        cerr << 0 << endl;
    }

    return 0;
}
