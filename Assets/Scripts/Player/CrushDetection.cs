using System;
using UnityEngine;

public class CrushDetection : MonoBehaviour
{
    public float crushTolerence;
    private GameObject player;
    private CapsuleCollider2D crushCollider;
    private CapsuleCollider2D mainCollider;
    private PlayerController playerController;
    private Rigidbody2D rb;
    private bool inCrushZone;

    void Start()
    {
        mainCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        playerController = GetComponent<PlayerController>();
    }

    private void Update()
    {
        // Debug.DrawRay(mainCollider.transform.position, Vector2.down * mainCollider.size.y, Color.yellow);
        // Debug.DrawRay(mainCollider.transform.position, Vector2.up * mainCollider.size.y, Color.yellow);
        
        // Debug.DrawRay(mainCollider.transform.position, Vector2.left * mainCollider.size.x, Color.green);
        // Debug.DrawRay(mainCollider.transform.position, Vector2.right * mainCollider.size.x, Color.green);
        
        if (inCrushZone)
        {
            float thresholdY = Mathf.Abs(Physics2D.Raycast(mainCollider.transform.position, Vector2.down, mainCollider.size.y).point.y -
                                        Physics2D.Raycast(mainCollider.transform.position, Vector2.up, mainCollider.size.y).point.y);
            
            float thresholdX = Mathf.Abs(Physics2D.Raycast(mainCollider.transform.position, Vector2.left, mainCollider.size.x).point.x -
                                         Physics2D.Raycast(mainCollider.transform.position, Vector2.right, mainCollider.size.x).point.x);
            
            if(thresholdY <= mainCollider.size.y - crushTolerence && thresholdY > 0f)
                Crush();
            if(thresholdX <= mainCollider.size.x - crushTolerence && thresholdX > 0f)
                Crush();
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
        {
            inCrushZone = true;
        }
    }
    
    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
        {
            inCrushZone = false;
        }
    }
    
    void Crush()
    {
        Debug.Log("Crush");
        playerController.CrushRespawn();
    }
}
