using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class Station : MonoBehaviour
{
    public float cameraDepth = 12f;

    [Header("DA Related")]
    public GameObject roomTrigger;
    public Transform camPoint;
    private PlayerController player;
    public GameObject ToFollow;
    private CameraFollow cameraFollow;
    public GameObject buttonUI;
    private bool onTrigger = false;
    private bool isCharging = false;

    [Header("DA Related")]
    public Transform coneFX;
    public Transform sphereFX;
    public Transform rayPoint;
    private LineRenderer line;
    public MeshRenderer spawnFX;
    public MeshRenderer spawnFX2;
    
    void Start()
    {
        player = FindFirstObjectByType<PlayerController>();
        line = GetComponent<LineRenderer>();
        cameraFollow = FindAnyObjectByType<CameraFollow>();
        
        line.SetPosition(0, rayPoint.position);
        line.enabled = false;

        // StartCoroutine(MaterializePlayer());
    }
    
    void Update()
    {
        if (isCharging)
        {
            coneFX.LookAt(player.transform.position);
            sphereFX.LookAt(player.transform.position);
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
            SaveSystem.Save();
        }
    }

    public void StopCharging()
    {
        isCharging = false;
        line.enabled = false;
        cameraFollow.ChangeMode(ToFollow.transform, cameraFollow.depthOffset);
    }

    public IEnumerator MaterializePlayer()
    {
        spawnFX.enabled = true;
        yield return new WaitForSeconds(1f);
        spawnFX2.enabled = true;
        yield return new WaitForSeconds(1f);
        spawnFX.enabled = false;
        yield return new WaitForSeconds(0.5f);
        spawnFX2.enabled = false;
        yield break;
    }
}
