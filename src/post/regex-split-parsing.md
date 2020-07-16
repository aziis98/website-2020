---
title: Regex Split Parsing
description: A description
date: 3 Luglio 2020
tags: 
    - regex
    - javascript
    - parsing
---

I found a cool tecnique to do simple parsing of a string by repetitive split of string using regular expression (and eccessive use of lookahaeds). 

I will show how I managed to parse polynomials using this tecnique and in the end I will some some other cool usage cases.

## Polynomials

The format I decided to use for polynomials is the following

```js
const p1 = "-4x^3 + x^2 - 17x + 1.5";
```

First lets remove all the spaces by appling 

```js
let _ = p1;
_ = _.replace(/\s+/, ''); // "-4x^3+x^2-17x+1.5"
```

Now we want to separate all various terms, a term is matched by the regular expression.
Now we want to separate all various terms, a term is matched by the regular expression.
Now we want to separate all various terms, a term is matched by the regular expression.

$$
\underbrace{\texttt{[-+]?}}_{\text{sign}} \,
\underbrace{\texttt{\textbackslash d+(\textbackslash.\textbackslash d+)?}}_{\text{coeficient}} \,
\dots
$$

Now we want to separate all various terms, a term is matched by the regular expression