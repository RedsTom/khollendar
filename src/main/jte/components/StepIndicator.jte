@param int currentStep

<div class="hidden lg:block mb-6">
    <div class="flex items-center gap-2 text-sm text-ctp-subtext0">
        <span class="@if(currentStep >= 1)text-ctp-blue font-bold@else text-ctp-subtext0@endif">
            Étape 1
        </span>
        <span class="w-6 sm:w-8 h-0.5 @if(currentStep >= 2)bg-ctp-blue@else bg-ctp-surface1@endif"></span>
        <span class="@if(currentStep >= 2)text-ctp-blue font-bold@else text-ctp-subtext0@endif">
            Étape 2
        </span>
        <span class="w-6 sm:w-8 h-0.5 @if(currentStep >= 3)bg-ctp-blue@else bg-ctp-surface1@endif"></span>
        <span class="@if(currentStep >= 3)text-ctp-blue font-bold@else text-ctp-subtext0@endif">
            Étape 3
        </span>
    </div>
</div>

