To run:

either

```
cd structful-zk && make
```

or

```
cd greedy-gen && python main.py Prover.toml 22 44
cp Prover.toml ../simple-zk/
cp Prover.toml ../structful-zk/
cd ../simple-zk
sed "s/VERTICES: u32 = 10/VERTICES: u32 = 22/" ../simple-zk/src/main.nr -i
sed "s/VERTICES: u32 = 10/VERTICES: u32 = 22/" ../structful-zk/src/main.nr -i
cd ../simple-zk
time nargo execute
cd ../structful-zk
time nargo execute
```

