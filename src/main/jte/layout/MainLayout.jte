@param String title
@param gg.jte.Content content
@param org.springframework.security.web.csrf.CsrfToken _csrf

<!doctype html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="icon" type="image/png" href="/favicon.ico"/>
    <title>
        Khôlle'n'Dar | ${title}
    </title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.29.2/feather.min.js"
            integrity="sha512-zMm7+ZQ8AZr1r3W8Z8lDATkH05QG5Gm2xc6MlsCdBz9l6oE8Y7IXByMgSm/rdRQrhuHt99HAYfMljBOEZ68q5A=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <link rel="stylesheet" href="/main.css">
</head>
<body class="bg-ctp-base text-ctp-text grid grid-rows-[auto_1fr_auto] min-h-screen">
<header class="bg-ctp-crust w-full flex items-center justify-between p-4">
    <a id="logo" class="flex gap-4 items-center hover:bg-ctp-surface0 p-3 rounded-lg" href="/">
        <img src="/images/logo.svg" alt="Logo" class="h-10 w-10">
        <h1 class="text-xl font-bold hidden sm:inline">Khôlle'n'Dar</h1>
    </a>

    <div class="flex items-center gap-4">
        <span class="text-ctp-subtext0 flex items-center gap-2">
            <span class="text-end">
                Double Licence<br/>
                Maths-Info
            </span>
            <svg class="h-12 w-12" viewBox="0 0 47.53 47.53" xmlns="http://www.w3.org/2000/svg">
              <path d="M36.38,24.23c.4-.51.77-1.01,1.1-1.52,2.05-3.16,2.47-5.97,1.2-7.92-1.27-1.95-4.02-2.69-7.73-2.09-.18.03-.37.07-.56.11-1.13-2.74-2.68-4.71-4.45-5.48-.23-.74-.91-1.29-1.73-1.29s-1.5.54-1.73,1.29c-1.78.78-3.32,2.74-4.45,5.49-3.84-.72-6.93-.12-8.29,1.97-1.51,2.32-.5,5.84,2.31,9.44-1.5,1.92-2.48,3.81-2.84,5.52-.64.28-1.08.92-1.08,1.66,0,.84.58,1.55,1.36,1.75.08.17.15.34.26.5,1,1.53,2.93,2.28,5.4,2.28.9,0,1.87-.1,2.89-.3,1.49,3.61,3.68,5.86,6.18,5.86s4.69-2.25,6.18-5.86c.19.04.38.08.56.11.58.09,1.13.14,1.67.17.32.54.9.9,1.56.9.79,0,1.46-.51,1.71-1.21,1.23-.36,2.18-1.02,2.79-1.95,1.27-1.95.84-4.76-1.2-7.92-.33-.51-.7-1.01-1.1-1.52h-.01ZM31.24,14.49c.74-.12,1.44-.18,2.07-.18,1.86,0,3.22.51,3.85,1.47.84,1.29.4,3.45-1.21,5.93-.24.37-.5.73-.77,1.1-.9-.99-1.92-1.95-3.04-2.88-.23-1.96-.6-3.78-1.11-5.39.07-.01.14-.03.22-.04h0ZM27.69,29.56c-1.18.77-2.34,1.43-3.47,1.99-1.16-.58-2.33-1.24-3.48-1.99-.98-.64-1.89-1.3-2.74-1.97-.1-1.07-.15-2.19-.15-3.37s.05-2.3.15-3.37c.84-.67,1.75-1.33,2.74-1.97,1.15-.75,2.32-1.41,3.49-2,1.13.57,2.29,1.23,3.46,2,.96.63,1.88,1.29,2.74,1.98.1,1.07.15,2.18.15,3.35s-.05,2.29-.15,3.35c-.86.69-1.77,1.35-2.74,1.98v.02ZM30.08,30.12c-.22,1.23-.49,2.37-.82,3.39-.96-.26-1.96-.6-2.97-1.01.8-.44,1.59-.9,2.39-1.42.48-.31.94-.63,1.4-.96ZM22.14,32.51c-1.04.43-2.03.76-2.97,1.02-.33-1.03-.61-2.17-.83-3.41.45.33.92.65,1.4.96.79.52,1.6.99,2.4,1.43ZM16.07,25.93c-.61-.57-1.17-1.14-1.67-1.7.51-.56,1.06-1.13,1.67-1.7-.02.56-.04,1.12-.04,1.7s.01,1.14.04,1.7ZM18.34,18.33c.22-1.24.5-2.39.83-3.42.94.26,1.93.6,2.96,1.03-.8.44-1.6.91-2.39,1.43-.48.31-.95.63-1.4.96ZM26.3,15.95c1.01-.41,2-.75,2.96-1.01.33,1.03.61,2.16.82,3.39-.46-.33-.92-.65-1.4-.96-.8-.52-1.59-.99-2.39-1.42h0ZM32.36,22.54c.59.56,1.14,1.12,1.65,1.69-.51.57-1.06,1.13-1.65,1.69.02-.56.04-1.12.04-1.69s-.01-1.13-.04-1.69ZM22.92,9.14c.33.33.79.54,1.29.54s.96-.21,1.29-.54c1.14.62,2.24,2.04,3.12,4.09-1.43.4-2.91.95-4.41,1.65-1.52-.71-3-1.26-4.42-1.66.88-2.05,1.98-3.46,3.12-4.08h.01ZM11.26,15.78c.63-.97,2.01-1.48,3.89-1.48.68,0,1.44.08,2.25.22-.51,1.62-.89,3.45-1.12,5.41-1.13.94-2.16,1.91-3.05,2.89-2.22-2.93-2.93-5.57-1.97-7.04ZM11.26,32.67h0c.31-.34.5-.78.5-1.26,0-.61-.3-1.14-.76-1.47.3-1.26,1.05-2.74,2.23-4.31.89.98,1.92,1.95,3.05,2.89.23,1.96.61,3.79,1.12,5.41-3.03.52-5.28.05-6.14-1.26ZM24.21,39.67c-1.57,0-3.2-1.63-4.41-4.45,1.41-.39,2.89-.96,4.4-1.66,1.5.7,2.99,1.26,4.43,1.66-1.22,2.82-2.84,4.46-4.41,4.46h-.01ZM37.16,32.67c-.34.52-.89.9-1.62,1.14-.33-.38-.82-.62-1.36-.62-.67,0-1.26.37-1.57.92-.44-.03-.89-.07-1.37-.15-.07,0-.14-.03-.22-.04.51-1.61.89-3.44,1.11-5.39,1.12-.93,2.14-1.9,3.04-2.88.28.37.54.73.77,1.1,1.61,2.48,2.05,4.65,1.21,5.94v-.02Z"
                    fill="currentColor"/>
              <path d="M24.21,20.59c-2.01,0-3.64,1.63-3.64,3.64s1.63,3.64,3.64,3.64,3.64-1.63,3.64-3.64-1.63-3.64-3.64-3.64ZM24.21,26.05c-1,0-1.82-.82-1.82-1.82s.82-1.82,1.82-1.82,1.82.82,1.82,1.82-.82,1.82-1.82,1.82Z"
                    fill="currentColor"/>
            </svg>
        </span>
    </div>
</header>
<main class="h-full relative">
    ${content}
</main>
<footer class="w-full flex flex-col md:flex-row gap-4 items-center justify-between p-4 bg-ctp-crust">
    <p class="text-center md:text-left">
        Copyright &copy; ${java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)} - Tom BUTIN - GNU GPL v3
    </p>

    <div id="buttons" class="flex gap-4">
        @if(fr.redstom.khollendar.utils.AuthUtils.authenticated())
            <form action="/logout" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>
                <button type="submit"
                        class="bg-ctp-red hover:bg-ctp-red/80 text-ctp-base px-4 py-2 rounded-lg flex gap-2 items-center justify-center">
                    <i data-feather="log-out" class="w-5 h-5"></i>
                    Déconnexion
                </button>
            </form>
        @else
            <a class="bg-ctp-surface0 hover:bg-ctp-surface1 px-4 py-2 rounded-lg flex gap-2 items-center justify-center"
               href="/login">
                <i data-feather="log-in" class="w-5 h-5"></i>
                Administrateur
            </a>
        @endif

        <a class="bg-ctp-surface0 hover:bg-ctp-surface1 px-4 py-2 rounded-lg flex gap-2 items-center justify-center"
           href="https://etulab.univ-amu.fr/b24013559/khollendar" target="_blank">
            <i data-feather="gitlab" class="w-5 h-5"></i>
            GitLab
        </a>
    </div>
</footer>

<script>
    feather.replace();
</script>
</body>
</html>
