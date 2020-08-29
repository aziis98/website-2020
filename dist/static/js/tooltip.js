import { html, render } from 'https://unpkg.com/lit-html?module';

const $tooltipContainer = document.getElementById('tooltip-container');
const tooltipData = {};

document.addEventListener('DOMContentLoaded', async e => {
    const request = await fetch('/static/data/tooltips.json');
    tooltipData = await request.json();
});

document.body.addEventListener('mousemove', e => {
    if (e.target.tagName === 'a' && tooltipData[e.target.href]) {
        showTooltip(e.target, tooltipData[e.target.href]);
    }
});

const tooltipComponent = ({}) => html`
    <div>Tooltip</div> 
`;

function showTooltip($element, content) {
    render(tooltipComponent(), $tooltipContainer);
}