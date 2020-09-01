---
title: Hypercube
description: Backport of a widget make for the old site
date: 2017/10/10
tags: 
    - math
    - webdev
---

Here is an hypercube, ported from the old website hosted on <a href="https://poisson.phc.dm.unipi.it/~delucreziis">https://poisson.phc.dm.unipi.it<wbr>/~delucreziis</a>.

<canvas width="400" height="400" id="canvas"></canvas>

<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/3.17.0/math.min.js"></script>
<script src="/static/js/hypercube.js"></script>
<style>
#canvas {
    display: block;
    margin: 0 auto;
    border: 1px solid #aaa;
}
</style>

## Explaination

**Warning.** Be aware that this is a bad explanation of some bad code so don't expect much for now. I'll try to enhance this code someday.

First lets define the canvas, the hypercube vertices and all edges (in index notation). So we have $\texttt{cubePoints} := \{ -1, 1\}^4$.

```javascript
const $canvas = document.querySelector('#canvas');

const cubePoints = [
	[-1, -1, -1, -1], [-1, -1, -1, 1], [-1, -1, 1, -1], [-1, -1, 1, 1],
	[-1, 1, -1, -1], [-1, 1, -1, 1], [-1, 1, 1, -1], [-1, 1, 1, 1],
	[1, -1, -1, -1], [1, -1, -1, 1], [1, -1, 1, -1], [1, -1, 1, 1],
	[1, 1, -1, -1], [1, 1, -1, 1], [1, 1, 1, -1], [1, 1, 1, 1]
];

const lines = [
	[0, 2, 6, 4, 0, 8, 10, 2, 3, 1, 9, 11, 3],
	[0, 1, 5, 7, 15, 13, 5, 4, 12, 14, 6],
	[8, 12, 13, 9, 8],
	[10, 11, 15, 14, 10],
	[6, 7, 3]
];
```

All the edges are drawn in batches, there isn't much math behind those sequences I just added indices until all correct edges where on the screen. An interesting problem might actually see if there is a list of vertices that produces a single non overlapping sequences of all the edges of the hypercube. 

[TODO: Better explain this part] The interesting bit is the rotation and projection code. The rotation in 4d in on the $O\hat x \hat w$ plane and after the projection there are two more rotations for simplicity. The projection first takes a 4d vector and projects it first in 3d by "further things more on the outside" and then projects those in 2d. (It looks like that I used the library <https://mathjs.org/> for doing all the matrix multiplications)

```javascript
function rotationMatrix4(theta) {
	return [
		[math.cos(theta), 0, 0, -math.sin(theta)],
		[              0, 1, 0,                0],
		[              0, 0, 1,                0],
		[math.sin(theta), 0, 0,  math.cos(theta)]
	];
}

function rotationMatrix3x(theta) {
	return [
		[1,               0,               0 ],
		[0, math.cos(theta), -math.sin(theta)],
		[0, math.sin(theta),  math.cos(theta)]
	];
}

function rotationMatrix3y(theta) {
	return [
		[ math.cos(theta), 0, math.sin(theta)],
		[               0, 1,               0],
		[-math.sin(theta), 0, math.cos(theta)]
	];
}

function project3d(vet4) {
    // Drops 4th component
    return vet4.slice(0, 3).map(it => it * Math.abs(vet4[3] + 2.0));
}

function project2d(vet3) {
    // Drops 3th component
	return vet3.slice(0, 2).map(it => 600.0 * it / (vet3[2] - 20.0));
}
```

At last there is the actual rendering code that computes all rotations and projection and draws the cube wireframe.

```javascript
let ticks = 0;
let angleY = 0;
let angleW = 0;

let inputState = 'none';

function render() {

	ticks++;

	const rotW = inputState == 'none' ? ticks / 200.0 * Math.PI / 2 : angleW;
	const rotY = inputState == 'none' ? ticks / 400.0 : angleY;

	const ctx = $canvas.getContext('2d');

	ctx.clearRect(0, 0, $canvas.width, $canvas.height);

	ctx.translate($canvas.width / 2, $canvas.height / 2);

	ctx.fillStyle = '#000';

	const projPoints = cubePoints.map((pt, i) => {


		const pt3 = project3d(math.multiply(rotationMatrix4(rotW), pt));

		const proj = project2d(
			math.multiply(
				rotationMatrix3x(Math.PI / 6),
				math.multiply(
					rotationMatrix3y(-rotY), 
					math.add([0, 0.3, 0], pt3)
				)
			)
		);

		return proj;

	});

	ctx.strokeStyle = '#333';

	lines.forEach(line => {

		ctx.beginPath();
		ctx.moveTo(projPoints[line[0]][0], projPoints[line[1]]);

		for (var i = 0; i < line.length; i++) {
			ctx.lineTo(projPoints[line[i]][0], projPoints[line[i]][1]);
		}

		ctx.stroke();
	});

	ctx.translate(-$canvas.width / 2, -$canvas.height / 2);

	requestAnimationFrame(render);

}

render();
```

and then there are some listeners for device orientation on mobile and mouse input for the desktop.

```javascript
window.addEventListener('deviceorientation', e => {
	if (e.alpha != null) {
		angleY = e.gamma / 90 * Math.PI * 3;
		angleW = e.beta / 180 * Math.PI * 2 + Math.PI / 4;
		inputState = 'gyro';
	}
});

$canvas.addEventListener('mouseenter', e => {
	if (inputState != 'gyro') inputState = 'mouse';
});

$canvas.addEventListener('mouseleave', e => {
	if (inputState != 'gyro') inputState = 'none';
});

$canvas.addEventListener('mousemove', e => {
	angleY = (e.offsetX / $canvas.width / 2 - 1) * Math.PI * 5.0;
	angleW = (e.offsetY / $canvas.height / 2 - 1) * Math.PI * 4;
});
```