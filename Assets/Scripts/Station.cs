using System;
using UnityEngine;
using UnityEngine.Events;

public class Station : MonoBehaviour
{
    public float cameraDepth = 12f;

    public GameObject roomTrigger;
    private PlayerController player;
    private LineRenderer line;
    private CameraFollow cameraFollow;
    
    private bool onTrigger = false;
    private bool isCharging = false;
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = true;
            player.onStation =  true;
            transform.GetChild(0).gameObject.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = false;
            player.onStation = false;
            transform.GetChild(0).gameObject.SetActive(false);
        }
    }

    public void StartCharging()
    {
        if (onTrigger)
        {
            isCharging = true;
            line.enabled = true;
            player.respawnPoint = transform;
            cameraFollow.ChangeMode(roomTrigger, cameraDepth);
        }
    }

    public void StopCharging()
    {
        isCharging = false;
        line.enabled = false;
        cameraFollow.ChangeMode(player.gameObject, cameraFollow.depthOffset);
    }
    void Start()
    {
        player = FindAnyObjectByType<PlayerController>();
        line = GetComponent<LineRenderer>();
        cameraFollow = FindAnyObjectByType<CameraFollow>();
        
        line.SetPosition(0, transform.position);
        line.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (isCharging)
        {
            line.SetPosition(1, player.transform.position);
        }
    }
}
