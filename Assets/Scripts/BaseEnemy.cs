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

    private void OnTriggerEnter2D(Collider2D other)
    {
        Debug.Log(other.name);
        if (other.CompareTag("Bubble"))
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
        }
        else if (other.CompareTag("PatternTrigger"))
            positiveMove = !positiveMove;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Bubble"))
            timeScale = normalTime;
    }

    void Update()
    {
        if (positiveMove)
            transform.position += new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
        else
            transform.position -= new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
    }

    private void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
