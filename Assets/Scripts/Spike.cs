using System;
using UnityEngine;

public class Spike : MonoBehaviour
{
    private TimeChanger timeChanger;
    private PlayerSound playerSound;
    private PlayerController playerController;
    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            // timeChanger.ChangeTime();
            playerSound.HurtSound();
            playerController.Pushback(transform.position);
        }
    }

    void Start()
    {
        timeChanger = GetComponent<TimeChanger>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerController = FindFirstObjectByType<PlayerController>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
