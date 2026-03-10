using System;
using UnityEngine;

public class BaseEnemy : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;

    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;

    public bool positiveMove = true;
    
    private PlayerController player;
    private TimeChanger time;

    private void OnTriggerEnter2D(Collider2D other)
    {
        // Debug.Log(other.name);
        // if (other.CompareTag("Bubble"))
        // {
        //     switch (globalTime.worldTime)
        //     {
        //         case WorldTime.ONE:
        //             timeScale = acceleratedTime;
        //             break;
        //         case WorldTime.TWO:
        //             timeScale = normalTime;
        //             break;
        //         case WorldTime.THREE:
        //             timeScale = slowedTime;
        //             break;
        //     }
        // }
        if (other.CompareTag("PatternTrigger"))
            positiveMove = !positiveMove;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Bubble"))
            timeScale = normalTime;
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            time.ChangeTime();
            player.Pushback(transform.position);
        }
    }

    void Update()
    {
        switch (globalTime.worldTime)
        {
            case WorldTime.ONE:
                timeScale = acceleratedTime;
                break;
            case WorldTime.TWO:
                timeScale = normalTime;
                break;
            case WorldTime.THREE:
                timeScale = slowedTime;
                break;
        }
        if (positiveMove)
            transform.position += new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
        else
            transform.position -= new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
    }

    private void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>();
        time = GetComponent<TimeChanger>();
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
