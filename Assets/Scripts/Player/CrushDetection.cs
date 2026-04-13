using System;
using UnityEngine;

public class CrushDetection : MonoBehaviour
{
    [Header("Système de Respawn")]
    private Transform tempCheckpoint;

    private float crushTolerence;
    private GameObject player;
    private CapsuleCollider2D crushCollider;
    private CapsuleCollider2D mainCollider;
    private PlayerController playerController;
    private Rigidbody2D rb;

    private int crushFactors;
    

    void Start()
    {
        player = transform.parent.gameObject;
        crushCollider = GetComponent<CapsuleCollider2D>();
        mainCollider = player.GetComponent<CapsuleCollider2D>();
        rb = player.GetComponent<Rigidbody2D>();
        playerController = player.GetComponent<PlayerController>();

        crushTolerence = playerController.crushTolerence;
        CalculateCrushBoxSize();
        tempCheckpoint = playerController.respawnPoint;
    }
    

    private void OnCollisionEnter2D(Collision2D other)
    {
        Debug.Log("Collision");
        crushFactors++;
        if (crushFactors > 1)
            Crush();
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        crushFactors--;
    }
    
    void Crush()
    {
        Debug.Log("Crush");
        playerController.CrushRespawn();
    }

    private void CalculateCrushBoxSize()
    {
        crushCollider.size = new Vector2(mainCollider.size.x - crushTolerence, mainCollider.size.y - crushTolerence);
    }
}
