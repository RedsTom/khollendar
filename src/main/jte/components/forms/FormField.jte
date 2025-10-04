@param String type = "text"
@param String id
@param String name
@param String label
@param String placeholder = ""
@param boolean required = false
@param String value = ""
@param String extraClasses = ""
@param String pattern = ""
@param String maxlength = "0"
@param String inputmode = ""
@param String helpText = ""
@param gg.jte.Content options = null

!{
    var inputClasses = "w-full p-2 bg-ctp-base border border-ctp-surface1 rounded-md text-ctp-text focus:outline-none focus:border-ctp-blue " + extraClasses;
    var requiredAttr = required ? "required" : "";

    String selectAttributes = "";
    String attributes = "";

    if (type.equals("select")) {
        // Pour les select, on construit les attributs différemment
        selectAttributes = "id=\"" + id + "\" name=\"" + name + "\" class=\"" + inputClasses + "\"";
        if (!requiredAttr.isEmpty()) selectAttributes += " " + requiredAttr;
    } else {
        // Pour les input, construction des attributs comme avant
        var placeholderAttr = !placeholder.isEmpty() ? "placeholder=\"" + placeholder + "\"" : "";
        var valueAttr = !value.isEmpty() ? "value=\"" + value + "\"" : "";
        var patternAttr = !pattern.isEmpty() ? "pattern=\"" + pattern + "\"" : "";
        var maxlengthAttr = !maxlength.isEmpty() ? "maxlength=\"" + maxlength + "\"" : "";
        var inputmodeAttr = !inputmode.isEmpty() ? "inputmode=\"" + inputmode + "\"" : "";

        // Assemblage des attributs
        attributes = "type=\"" + type + "\" id=\"" + id + "\" name=\"" + name + "\" class=\"" + inputClasses + "\"";
        if (!requiredAttr.isEmpty()) attributes += " " + requiredAttr;
        if (!placeholderAttr.isEmpty()) attributes += " " + placeholderAttr;
        if (!valueAttr.isEmpty()) attributes += " " + valueAttr;
        if (!patternAttr.isEmpty()) attributes += " " + patternAttr;
        if (!maxlengthAttr.isEmpty()) attributes += " " + maxlengthAttr;
        if (!inputmodeAttr.isEmpty()) attributes += " " + inputmodeAttr;
    }
}

<div class="mb-4">
    <label for="${id}" class="block text-sm font-medium mb-2">${label}</label>
    @if(type.equals("select"))
        $unsafe{"<select " + selectAttributes + ">"}
            @if(!placeholder.isEmpty())
                <option value="" disabled $unsafe{value.isEmpty() ? "selected" : ""}>${placeholder}</option>
            @endif
            @if(options != null)
                ${options}
            @endif
        $unsafe{"</select>"}
    @else
        $unsafe{"<input " + attributes + ">"}
    @endif
    @if(!helpText.isEmpty())
        <p class="mt-1 text-sm text-ctp-subtext0">${helpText}</p>
    @endif
</div>