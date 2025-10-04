@param int currentStep
@param int totalSteps = 3

<div class="w-full bg-ctp-surface1 rounded-full h-2 mb-4">
    <div class="bg-ctp-blue h-2 rounded-full transition-all duration-300"
         style="width: ${(currentStep * 100.0 / totalSteps)}%">
    </div>
</div>
<p class="text-sm text-ctp-subtext0">Étape ${currentStep} sur ${totalSteps}</p>

