using System;
using UnityEngine;
using UnityEngine.Events;

public class FinalRoom : MonoBehaviour
{
    public float cameraDepth = 12f;
    private PlayerController playerController;
    private CameraFollow cameraFollow;
    public GameObject ToFollow;
    public Transform cameraPoint;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerController.onFinal =  true;
            cameraFollow.ChangeMode(cameraPoint, cameraDepth);
        }    
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerController.onFinal = false;
            cameraFollow.ChangeMode(ToFollow.transform, cameraFollow.depthOffset);
        }
    }

    void Start()
    {
        playerController = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
