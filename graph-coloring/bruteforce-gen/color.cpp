#include <cstdint>
#include <iostream>
#include <memory>
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

// Finds a 3-coloring of the given graph by trying all possibilities. If there
// is no solution, returns false; true otherwise.
bool find_coloring(const Neighbors &neighbors, Coloring &coloring) {
    Coloring initial_coloring = coloring;

    uint64_t heartbeat = 0;
    cout << "heartbeat:" << endl;
    do {
        if (++heartbeat % 100000000 == 0) {
            cout << heartbeat << endl;
        }
        if (check_coloring(neighbors, coloring)) {
            return true;
        }

        next_coloring(coloring);

        if (coloring == initial_coloring) {
            // All possibilities have been tried; give up.
            return false;
        }
    } while (true);
}

void print_coloring(const Coloring &coloring) {
    for (auto c : coloring) {
        cout << c << ' ';
    }
    cout << endl;
}

// Optimal graph 3-coloring using brute-force.
int main() {
    auto neighbors = read_input();

    vector<size_t> coloring(neighbors.size(), 0);
    if (find_coloring(neighbors, coloring)) {
        cout << 1 << endl;
        print_coloring(coloring);
    } else {
        cout << 0 << endl;
    }

    return 0;
}
