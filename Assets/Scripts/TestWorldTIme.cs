using System;
using UnityEngine;

public class TestWorldTIme : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;

    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;

    private void OnTriggerEnter2D(Collider2D other)
    {
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
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Bubble"))
            timeScale = normalTime;
    }

    void Update()
    {
        transform.position += new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
    }
}
