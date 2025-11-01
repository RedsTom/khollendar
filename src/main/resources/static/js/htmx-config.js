const csrfHeader = document.querySelector('meta[name=csrf-header]').getAttribute("content");
const csrfToken = document.querySelector('meta[name=csrf-token]').getAttribute("content");

document.body.addEventListener("htmx:configRequest", (event) => {
    console.log("Adding CSRF token to request headers", csrfHeader, csrfToken);
    event.detail.headers[csrfHeader] = csrfToken;
})