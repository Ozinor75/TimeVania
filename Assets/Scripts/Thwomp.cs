using UnityEngine;

public class Thwomp : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;

    [Header("Speeds")] public float upSpeed;
    public float downSpeed;

    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;

    public bool positiveMove = true;

    private void OnTriggerEnter2D(Collider2D other)
    {
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

    void FixedUpdate()
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
            transform.position += new Vector3(0, upSpeed * timeScale * Time.deltaTime, 0);
        else
        {
            Vector3 targetPosition = transform.position - new Vector3(0, 1, 0);
            transform.position = Vector3.Lerp(transform.position, targetPosition, downSpeed * timeScale * Time.deltaTime);
        }
    }

    private void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
