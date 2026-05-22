using System;
using UnityEngine;
using UnityEngine.Events;

public class Station : MonoBehaviour
{
    public float cameraDepth = 12f;

    public GameObject roomTrigger;
    public Transform camPoint;
    private PlayerController player;
    public GameObject ToFollow;
    private LineRenderer line;
    private CameraFollow cameraFollow;

    public GameObject buttonUI;
    private bool onTrigger = false;
    private bool isCharging = false;
    public Transform rayPoint;
    
    void Start()
    {
        player = FindFirstObjectByType<PlayerController>();
        line = GetComponent<LineRenderer>();
        cameraFollow = FindAnyObjectByType<CameraFollow>();
        
        line.SetPosition(0, rayPoint.position);
        line.enabled = false;
    }
    
    void Update()
    {
        if (isCharging)
        {
            line.SetPosition(1, player.transform.position);
        }
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = true;
            player.onStation =  true;
            buttonUI.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = false;
            player.onStation = false;
            buttonUI.SetActive(false);
        }
    }

    public void StartCharging()
    {
        if (onTrigger)
        {
            isCharging = true;
            line.enabled = true;
            player.respawnPoint = transform;
            cameraFollow.ChangeMode(camPoint, cameraDepth);
        }
    }

    public void StopCharging()
    {
        isCharging = false;
        line.enabled = false;
        cameraFollow.ChangeMode(ToFollow.transform, cameraFollow.depthOffset);
    }
}
