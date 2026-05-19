using UnityEngine;
using TMPro;

public class TimerChallenge : MonoBehaviour
{
    private float elapsedTime = 0f;
    private TextMeshProUGUI timerText;
    
    // Notre interrupteur : vrai par défaut pour que le timer se lance tout de suite
    private bool isRunning = false; 

    void Start()
    {
        timerText = GetComponent<TextMeshProUGUI>();
    }

    void Update()
    {
        // On n'ajoute du temps que si le timer est "en marche"
        if (isRunning)
        {
            elapsedTime += Time.deltaTime;

            if (timerText != null)
            {
                timerText.text = elapsedTime.ToString("F2"); 
            }
        }
    }

    // Fonction publique qui pourra être appelée depuis n'importe quel autre script
    public void StartTimer()
    {
        if (isRunning)
            isRunning = false;
        else
        {
            elapsedTime = 0f;
            isRunning = true;
        }
    }
}