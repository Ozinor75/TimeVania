using System;
using UnityEngine;

public class BaseEnemy : MonoBehaviour
{
    [Header("Boundaries")]
    public Transform enemy;
    public Transform start;
    public Transform end;
    public AnimationCurve curve;
    public float duration;
    private float t;
    private float r;

    [Header("Time")]
    public GlobalTime manager;

    private void Start()
    {
        // enemy = transform.GetChild(0);
        enemy.position = start.position;
    }

    void Update()
    {
        t += Time.deltaTime  * manager.active;
        t %= duration * 2;
        r = t / duration;
        
        enemy.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
    }
    
    // Mettre ca sur le player, et avec un tag.
    
    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            // time.ChangeTime();
            other.gameObject.GetComponent<PlayerController>().Pushback(transform.position);
            // player.Pushback(transform.position);
        }
    }
}