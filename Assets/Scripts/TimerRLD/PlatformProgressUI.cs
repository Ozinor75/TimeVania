using UnityEngine;
using TMPro;

public class PlatformProgressUI : MonoBehaviour
{
    [Header("Références")]
    public PlatformMovement platform;
    public TextMeshProUGUI progressText;

    void Update()
    {
        // On s'assure que les références sont bien assignées pour éviter les erreurs
        if (platform != null && progressText != null)
        {
            // Dans ton script, 'r' va de 0 à 2 (à cause du modulo duration * 2).
            // On utilise Mathf.PingPong pour transformer cette valeur en un aller-retour propre de 0 à 1.
            float progress = Mathf.PingPong(platform.r, 1f);

            // On convertit cette valeur en pourcentage (de 0 à 100)
            // "F0" permet de ne pas afficher de chiffres après la virgule
            progressText.text = $"Temps : {(progress * 100).ToString("F0")} %";
        }
    }
}