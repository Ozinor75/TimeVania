using UnityEngine;

public class MovingAndDestroy : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;

    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;
    public bool Up;

    public bool positiveMove = true;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("PatternTrigger"))
            positiveMove = !positiveMove;
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
        if (!Up)
        {
            if (positiveMove)
                transform.position += new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
            else
                transform.position -= new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
        }
        else
        {
            if (positiveMove)
                transform.position += new Vector3(0, 2 * timeScale * Time.deltaTime, 0);
            else
                transform.position -= new Vector3(0, 2 * timeScale * Time.deltaTime, 0);
        }
    }

    private void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
