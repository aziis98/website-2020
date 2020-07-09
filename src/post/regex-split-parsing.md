---
title: Regex Split Parsing
description: 
author: 
date: 2020-07-03T14:06:01+02:00
tags: [a, b, c, d]
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

Now we want to separate all various terms, a term is matched by the regular expression

$$
\underbrace{\texttt{[-+]?}}_{\text{sign}}
\underbrace{\texttt{\textbackslash d+(\textbackslash.\textbackslash d+)?}}_{\text{coeficient}}
$$