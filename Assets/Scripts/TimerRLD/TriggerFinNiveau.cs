using UnityEngine;

public class TriggerFinNiveau : MonoBehaviour
{
    // Glisse ton GameObject "Texte (Timer)" contenant le script TimerChallenge dans cette case depuis l'inspecteur
    public TimerChallenge timerScript;
    public CustomInputs playerControls;

    // --- AJOUTS ---
    // On instancie l'objet contenant les inputs au tout début
    private void Awake()
    {
        playerControls = new CustomInputs();
    }

    // On active la lecture des touches quand l'objet est activé
    private void OnEnable()
    {
        playerControls.Enable();
    }

    // On désactive la lecture (bonne pratique pour éviter des bugs de mémoire)
    private void OnDisable()
    {
        playerControls.Disable();
    }
    // --------------

    private void OnTriggerEnter2D(Collider2D collision)
    {
        // On vérifie si c'est bien le joueur qui touche le trigger (assure-toi que ton joueur a le tag "Player")
        if (collision.CompareTag("Player"))
        {
            // On appelle la fonction pour stopper le timer
            if (timerScript != null)
            {
                timerScript.StartTimer();
            }
        }
    }

    void Update()
    {
        // Maintenant playerControls n'est plus nul, cette ligne fonctionnera
        if (playerControls.DEBUG.TimerReset.IsPressed())
        {
            timerScript.StartTimer();
        }
    }
}