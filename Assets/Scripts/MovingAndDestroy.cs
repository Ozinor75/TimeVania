using UnityEngine;

public class MovingAndDestroy : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;

    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;
    public bool Up;
    public bool Down;
    public bool Left;
    public bool Right;
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("DestroyTrigger"))
        {
            foreach (Transform child in transform)
            { 
                if (child.CompareTag("Player"))
                {
                    child.SetParent(null);
                    break; 
                }
            }
            Destroy(gameObject);
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
        if (Right)
        { 
            transform.position += new Vector3(2 * timeScale * Time.deltaTime, 0, 0);
        }
        else if (Left)
        {
            transform.position += new Vector3(-2 * timeScale * Time.deltaTime, 0, 0);
        }
        else if (Up)
        {
            transform.position += new Vector3(0, 2 * timeScale * Time.deltaTime, 0);
        }
        else if (Down)
        {
            transform.position += new Vector3(0, -2 * timeScale * Time.deltaTime, 0);
        }
            
    }

    private void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
