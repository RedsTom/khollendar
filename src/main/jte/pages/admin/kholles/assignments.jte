@param org.springframework.security.web.csrf.CsrfToken _csrf
@param fr.redstom.khollendar.entity.KholleSession session
@param java.util.List<fr.redstom.khollendar.entity.KholleAssignment> assignments
@param java.util.Map<Long, java.util.List<fr.redstom.khollendar.entity.KholleAssignment>> assignmentsBySlot

@template.layout.MainLayout(
title = "Gestion des affectations",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4 max-w-6xl">
    <div class="mb-6">
        @template.components.navigation.Breadcrumb(
        content = @`
            <a href="/" class="hover:text-ctp-blue transition-colors">
                Accueil
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                Sessions de khôlles
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                ${session.subject()}
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <span class="text-ctp-text">Gestion des affectations</span>
        `
        )
    </div>

    @template.components.ui.Card(
    content = @`
        @template.fragments.kholles.SessionHeader(
            session = session,
            actionButtons = @``
        )

        <!-- Vue en tableau pour les écrans moyens et grands -->
        @template.fragments.admin.AssignmentsTable(
            session = session,
            assignments = assignments,
            assignmentsBySlot = assignmentsBySlot
        )
    `)
    </div>

    <!-- Modal pour modifier l'affectation (sera chargé dynamiquement) -->
    <div id="edit-assignment-modal"></div>
`)
