using TMPro;
using UnityEngine;

public class RLDtimer : MonoBehaviour
{
    private bool CanTimer = false;
    private float timer = 0f;
    public TextMeshProUGUI timerText;
    
    private PlayerController playerController;

    void Start()
    {
        playerController = FindAnyObjectByType<PlayerController>();
    }

    void Update()
    {
        bool isMoving = Mathf.Abs(playerController.movementLeftRight) > 0.1f;

        // 2. Gestion de l'état du timer
        if (isMoving)
        {
            // Si le timer était en pause (CanTimer == false), c'est qu'on 
            // vient tout juste de commencer à bouger à cette frame précise.
            if (!CanTimer)
            {
                ResetTimer(); // On remet à zéro une seule fois
                CanTimer = true; // On lance le chrono
            }
        }
        else
        {
            // Le joueur ne bouge plus, on arrête le timer (il se met en pause, sans se reset)
            CanTimer = false;
        }

        // 3. Calcul du temps
        if (CanTimer)
        {
            timer += Time.deltaTime;
        }

        // 4. Mise à jour de l'affichage
        if (timerText != null)
        {
            timerText.text = timer.ToString("F2");
        }
    }

    public void LaunchTimer()
    { 
        CanTimer = true;
    }

    public void ResetTimer()
    {
        timer = 0f;
    }
}