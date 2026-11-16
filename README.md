# autoheal

when a predicate fails its tests, regenerate it from them. The tests are Input-Output pairs; the current version and its replacements come from a space of simple list programs (one step, or one step after another). autoheal keeps the current version if it passes, else returns the simplest version in the space that passes every test, or says it cannot heal (no version passes).

## Use

```prolog
?- use_module(prolog/autoheal).
?- heal(prim(reverse), [[1,2]-[1,2], [2,1]-[1,2]], H).     % H = healed(prim(msort))
?- heal(prim(msort), [[2,1]-[1,2]], H).                   % H = already_passes
?- heal(prim(inc), [[1]-[5,5]], H).                       % H = cannot_heal
```

## Proofs

`proofs/theorems.pl` proves 5 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every program in the space as the truth, test sets of one or two inputs of length 0..2 over 1..3,

1. A healed version passes every test.
2. A version that already passes is never touched.
3. Tests made from a program in the space can always be healed.
4. The heal is a simplest one: no single step passes when it returns two steps.
5. failures lists exactly the failing tests.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
