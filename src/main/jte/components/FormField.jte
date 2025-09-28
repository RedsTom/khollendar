@param String type = "text"
@param String id
@param String name
@param String label
@param String placeholder = ""
@param boolean required = false
@param String value = ""
@param String extraClasses = ""

!{var inputClasses = "w-full p-2 bg-ctp-base border border-ctp-surface1 rounded-md text-ctp-text focus:outline-none focus:border-ctp-blue " + extraClasses;}

<div class="mb-4">
    <label for="${id}" class="block text-sm font-medium mb-2">${label}</label>
    @if(type.equals("text"))
        @if(required)
            @if(!placeholder.isEmpty())
                @if(!value.isEmpty())
                    <input type="text" id="${id}" name="${name}" required value="${value}" placeholder="${placeholder}" class="${inputClasses}">
                @else
                    <input type="text" id="${id}" name="${name}" required placeholder="${placeholder}" class="${inputClasses}">
                @endif
            @else
                @if(!value.isEmpty())
                    <input type="text" id="${id}" name="${name}" required value="${value}" class="${inputClasses}">
                @else
                    <input type="text" id="${id}" name="${name}" required class="${inputClasses}">
                @endif
            @endif
        @else
            @if(!placeholder.isEmpty())
                @if(!value.isEmpty())
                    <input type="text" id="${id}" name="${name}" value="${value}" placeholder="${placeholder}" class="${inputClasses}">
                @else
                    <input type="text" id="${id}" name="${name}" placeholder="${placeholder}" class="${inputClasses}">
                @endif
            @else
                @if(!value.isEmpty())
                    <input type="text" id="${id}" name="${name}" value="${value}" class="${inputClasses}">
                @else
                    <input type="text" id="${id}" name="${name}" class="${inputClasses}">
                @endif
            @endif
        @endif
    @elseif(type.equals("password"))
        @if(required)
            @if(!placeholder.isEmpty())
                <input type="password" id="${id}" name="${name}" required placeholder="${placeholder}" class="${inputClasses}">
            @else
                <input type="password" id="${id}" name="${name}" required class="${inputClasses}">
            @endif
        @else
            @if(!placeholder.isEmpty())
                <input type="password" id="${id}" name="${name}" placeholder="${placeholder}" class="${inputClasses}">
            @else
                <input type="password" id="${id}" name="${name}" class="${inputClasses}">
            @endif
        @endif
    @elseif(type.equals("email"))
        @if(required)
            @if(!placeholder.isEmpty())
                @if(!value.isEmpty())
                    <input type="email" id="${id}" name="${name}" required value="${value}" placeholder="${placeholder}" class="${inputClasses}">
                @else
                    <input type="email" id="${id}" name="${name}" required placeholder="${placeholder}" class="${inputClasses}">
                @endif
            @else
                @if(!value.isEmpty())
                    <input type="email" id="${id}" name="${name}" required value="${value}" class="${inputClasses}">
                @else
                    <input type="email" id="${id}" name="${name}" required class="${inputClasses}">
                @endif
            @endif
        @else
            @if(!placeholder.isEmpty())
                @if(!value.isEmpty())
                    <input type="email" id="${id}" name="${name}" value="${value}" placeholder="${placeholder}" class="${inputClasses}">
                @else
                    <input type="email" id="${id}" name="${name}" placeholder="${placeholder}" class="${inputClasses}">
                @endif
            @else
                @if(!value.isEmpty())
                    <input type="email" id="${id}" name="${name}" value="${value}" class="${inputClasses}">
                @else
                    <input type="email" id="${id}" name="${name}" class="${inputClasses}">
                @endif
            @endif
        @endif
    @endif
</div>
