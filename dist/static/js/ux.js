
if (location.host !== 'aziis98.com') {
    const $nav_appunti = document.getElementById('nav-unipi');
    $nav_appunti.style.display = '';
}

window.addEventListener('scroll', e => {
    document.body.classList.toggle('not-on-top', window.scrollY > 30)
});
