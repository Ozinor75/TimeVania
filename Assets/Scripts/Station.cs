using System;
using UnityEngine;
using UnityEngine.Events;

public class Station : MonoBehaviour
{
    private PlayerController player;
    private LineRenderer line;
    
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
            player.StartPos = new Vector2(transform.position.x, transform.position.y);
        }
    }

    public void StopCharging()
    {
        isCharging = false;
        line.enabled = false;
    }
    void Start()
    {
        player = FindAnyObjectByType<PlayerController>();
        line = GetComponent<LineRenderer>();
        
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
