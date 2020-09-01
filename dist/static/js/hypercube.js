
/*

MIT License

Copyright (c) 2017 Antonio De Lucreziis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

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

function rotationMatrix3x(theta) {
	return [
		[1, 0, 0],
		[0, math.cos(theta), -math.sin(theta)],
		[0, math.sin(theta), math.cos(theta)]
	];
}

function rotationMatrix3y(theta) {
	return [
		[math.cos(theta), 0, math.sin(theta)],
		[0, 1, 0],
		[-math.sin(theta), 0, math.cos(theta)]
	];
}

function rotationMatrix4(theta) {
	return [
		[math.cos(theta), 0, 0, -math.sin(theta)],
		[0, 1, 0, 0],
		[0, 0, 1, 0],
		[math.sin(theta), 0, 0, math.cos(theta)]
	];
}

function project2d(vet3) {
	return vet3.slice(0, 2).map(it => 600.0 * it / (vet3[2] - 20.0));
}

function project3d(vet4) {
	return vet4.slice(0, 3).map(it => it * Math.abs(vet4[3] + 2.0));
}

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