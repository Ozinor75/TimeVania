using System;
using UnityEngine;

public class AbsorptionBoost : MonoBehaviour
{
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    private PlayerController playerController;
    
    public GameObject buttonUI;
    private bool onTrigger;
    
    void Start()
    {
        playerController = FindFirstObjectByType<PlayerController>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
    }

    public void MakeBoost()
    {
        
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            onTrigger = true;
            playerController.boostTrigger = transform;
            buttonUI.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        onTrigger = false;
        playerController.boostTrigger = null;
        buttonUI.SetActive(false);
    }
}
