# Benchmark runner for [OCCAM](https://github.com/SRI-CSL/OCCAM) #

To run OCCAM on a set of benchmarks and show metrics, type:

	runbench.py --sets="portfolio.set"

If you want to run more than one benchmark set then add more .set
files in the option `--sets` separated by comma:

	runbench.py --sets="portfolio.set,spec2006.set"

If you want to pass extra options to `slash` then type:

	runbench.py --sets="portfolio.set" --slash-opts="--disable-inlining"

If you want to pass multiple options by separating them by comma:

	runbench.py --sets="portfolio.set" --slash-opts="--disable-inlining,--enable-config-prime"

If you want to add a timeout or memory limit then type:

	runbench.py --sets="portfolio.set" --cpu=60 --mem=4096
	
By default, `runbench.py` runs OCCAM on the set of benchmarks selected
by option `--sets` and displays the number of functions, number of
instructions, etc. before and after the specialization takes
place. The option `--sets` is mandatory and expects a list of .set
files separated by comma.

The options `--cpu` and `--mem` set limits on CPU (in seconds) and
memory (in MB) for running OCCAM. The compilation of the programs is
unconstrained.

`runbench.py` reads from the `*.set` files to select which benchmarks
to run.  Each `*.set` file is in JSON format. For each benchmark,
there are at three fields: `dirname`, a relative path wrt environment
`OCCAM_HOME` variable, `execname`, the name of the executable, and
`enabled` whether the benchmark is enabled or not. That directory must
contain `Makefile` and `build.sh`. The makefile generates the bitcode
for the benchmark, and `build.sh` runs OCCAM on it. The assumption is
that after running `build.sh` two executables are generated: one with
suffix `_orig` and the other with suffix `_slashed`. The executables
are used by option `--rop` so it is important to follow this
convention.

For instance, the output of `runbench.py` might look like this:

```
Program Reduction: (B:before and A:after OCCAM)

Program    B Fun   A Fun   % Fun Red   B Ins    A Ins   % Ins Red   B Mem Ins   A Mem Ins   % Mem Ins Red
tree         106      93          12    7409     8921         -20        1615        1186              26
readelf      384     281          26   83390   111227         -33        6117        7714             -26
bzip2         92      41          55   22047    19055          13        4761        4303               9
mcf           43      22          48    2592     2388           7         654         488              25
```

## Benchmark categories ## 

- `portfolio`: some real applications 
- `spec2006`: SPEC 2006 benchmarks
- `coreutils`: coreutils benchmarks

## Deprecated options which are not maintained anymore ##

The option `--rop` shows also the number of ROP, JOP, and SYS gadgets,
before and after specialization.

```
Gadget Reduction: (B:before and A:after OCCAM)

Program    B ROP   A ROP   % ROP Red   B SYS   A SYS   % SYS Red   B JOP   A JOP   % JOP Red
tree         313     256          18       0       0           0      64      39          39
readelf     4007    3868           3       1       3        -200    2276     873          61
bzip2        479     971        -102       0       0           0      60     140        -133
mcf          168     115          31       0       0           0       0       0           0

```

`Red` means reduction. If the percentage is negative then it means
that there was an increase.


 
---

This material is based upon work supported by the National Science Foundation under Grant [ACI-1440800](http://www.nsf.gov/awardsearch/showAward?AWD_ID=1440800). Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.

