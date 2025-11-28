const csrfHeader = document.querySelector('meta[name=csrf-header]').getAttribute("content");
const csrfToken = document.querySelector('meta[name=csrf-token]').getAttribute("content");

document.body.addEventListener("htmx:configRequest", (event) => {
    event.detail.headers[csrfHeader] = csrfToken;
})