---
title: Regex Split Parsing
description: A description
date: 3 June 2020
tags: 
    - regex
    - javascript
    - parsing
---

I came up with a cool tecnique to easily parse a string by repetitive split using regular expression and the eccessive use of lookahaeds. 

I will show how I managed to parse polynomials using this tecnique and in the end I will show some other cool use cases.

## Polynomials

The format I decided to use for polynomials is the following

```js
const p1 = "-4x^3 + x^2 - 17x + 1.5";
```

First lets remove all the spaces by appling 

```js
p1.replace(/\s+/g, ''); // "-4x^3+x^2-17x+1.5"
```

Now we want to separate all various terms using a single split operation. We can notice that there is always a sign between terms but to split exactly before it we need a lookhaed. So the next step is

<!-- Let first define a regex for matching all the terms, so anything from `x` to `-1.23y^3`. Let's use something like the following -->

<!-- $$
\underbrace{\texttt{[-+]?}}_{\text{sign}} \,
\texttt{(} \,
\underbrace{\texttt{\textbackslash d+(\textbackslash.\textbackslash d+)?[a-z]}}_{\text{var and coeficient}} \,
\texttt{|} \,
\underbrace{\texttt{[a-z]}}_{\text{only var}} \,
\texttt{|} \,
\underbrace{\texttt{\textbackslash d+(\textbackslash.\textbackslash d+)?}}_{\text{only coeficient}} \,
\texttt{)} \,
\underbrace{\texttt{(\textbackslash\verb!^!\textbackslash d+)?}}_{\text{power}}
$$  -->


<!-- the only thing to comment here is that the three cases for the var and coeficient is necessary as only using `(\d+(\.\d+)?)?[a-z]?` matches also the empty string we don't want that. We can now split a polynomial using the previous regex wrapped in a lookahaed pattern to only split at polynomial boundaries -->

```js
p1
.replace(/\s+/g, '')
.split(/(?=[+-])/, '')   
// ["-4x^3", "+x^2", "-17x", "+1.5"]
```

Now using the same pattern we can sub-split each single term

```js
p1
.replace(/\s+/g, '')
.split(/(?=[+-])/, '')   
.map(term => {
    let [coeficient, monomial] = term.split(/(?=[a-z](?:\^\d+)?)/);
    // ...
})
```

it seams that in the call `term.split(/(?=[a-z](?:\^\d+)?)/);` used to split each term in a coeficient+monomial it is necessary to use a non capturing group for the exponent part. Then we have three cases: 

- one without coeficient (`"x^8"` gets split to `["x^8", undefined]`)
- one with just the sign that has to be expanded to $1$ or $-1$
- otherwise the coeficient is a valid number

```js
if (coeficient.match(/^[+-]?\d+(\.\d+)?$/)) {
    coeficient = parseFloat(coeficient);
}
else if (coeficient.match(/^[+-]$/)) {
    // Edge case
    coeficient = coeficient === '+' ? 1 : -1;
}
else {
    monomial = coeficient;
    coeficient = 1;
}
```

at last we are just left with splitting the variable and power and conerting the latter to an integer. In the end we have the following code

```js
p1
.replace(/\s+/g, '')
.split(/(?=[+-])/, '')   
.map(term => {
    let [coeficient, monomial] = term.split(/(?=[a-z](?:\^\d+)?)/);

    if (coeficient.match(/^[+-]?\d+(\.\d+)?$/)) {
        coeficient = parseFloat(coeficient);
    }
    else if (coeficient.match(/^[+-]$/)) {
        // Edge case
        coeficient = coeficient === '+' ? 1 : -1;
    }
    else {
        monomial = coeficient;
        coeficient = 1;
    }

    if (!monomial)
        return { coeficient };
    else {
        let [variable, power] = monomial.split(/\^/);
        power = parseInt(power || 1);

        return { coeficient, variable, power };
    }
})
// [
//     { coeficient: -4, variable: 'x', power: 3 }, 
//     { coeficient:  1, variable: 'x', power: 2 }, 
//     { coeficient: 17, variable: 'x', power: 1 }, 
//     { coeficient: 1.5 }
// ]
```