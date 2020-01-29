## VOIR COMMENT UNE DEPENDANCE EST VRAI
## c quoi tuple

```
    A   B     C
t1  10  b1    c1
t2  10  b2    c2
t3  11  b4    c3
t4  12
t5  13
t6  14


```

>depandance
>>
> A -> B (fausse) T1[A] = t2[A]= 10

                                      b1      by
> C -> B = t1[C] = t3[C] = c1 mais T1[B] != T3[B]

>>
> B -> A : b determine A ? ==== (faisse) T1[B] = T5[B] = bA mais T1[A] != T5[A]
>>
>

> C -> A : fausse
