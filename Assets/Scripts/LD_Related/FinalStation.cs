using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class FinalStation : MonoBehaviour
{
    [Header("GP Related")]
    public GameObject roomTrigger;
    public Transform camPoint;
    private PlayerController player;
    public GameObject ToFollow;
    private CameraFollow cameraFollow;
    private Image winScreen;
    public GameObject buttonUI;
    public bool isPlayerStation = false;
    private bool onTrigger = false;
    private bool isCharging = false;

    [Header("DA Related")]
    public Transform coneFX;
    public Transform sphereFX;
    public Transform rayPoint;
    public MeshRenderer spawnFX;
    public MeshRenderer spawnFX2;
    
    void Start()
    {
        winScreen = GameObject.FindGameObjectWithTag("WinScreen").GetComponent<Image>();
        player = FindFirstObjectByType<PlayerController>();
        cameraFollow = FindAnyObjectByType<CameraFollow>();
    }
    
    void Update()
    {
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = true;
            buttonUI.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            onTrigger = false;
            buttonUI.SetActive(false);
        }
    }

    public IEnumerator Finale()
    {
        yield return new WaitForSecondsRealtime(3f);
        SceneManager.LoadScene("Main_Menu");
    }
    public void MakeFinale()
    {
        if (onTrigger)
        {
            player.CanMove = false;
            winScreen.enabled = true;
            SaveSystem.Save();
            StartCoroutine(Finale());
        }
    }
}
