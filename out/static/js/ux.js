
window.addEventListener('scroll', e => {
    document.body.classList.toggle('not-on-top', window.scrollY > 30)
});
