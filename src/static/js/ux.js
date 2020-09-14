
if (location.host !== 'aziis98.com') {
    const $nav_appunti = document.getElementById('nav-unipi');
    $nav_appunti.style.display = '';
}

window.addEventListener('scroll', e => {
    document.body.classList.toggle('not-on-top', window.scrollY > 30)
});

// Just prevents "text"-scraping bots from seeing the email directly.
customElements.define('antispam-email', class extends HTMLElement {
    constructor() {
        super();

        const EMAIL = 'antonio.delucreziis' + '@' + 'gmail.com';
        this.innerHTML = `<a href="mailto:${EMAIL}">${EMAIL}</a>`;
    }
});


