using UnityEngine;

public class MovingAndDestroy : MonoBehaviour
{
    [Header("Movement")]
    public Transform movable;
    private float t;
    private float r;
    private WorldEvents worldEvents;

    [Header("Heritage")]
    public AnimationCurve curve;
    public float duration;
    public GlobalTime manager;
    public Transform start;
    public Transform end;
    
    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        worldEvents = FindFirstObjectByType<WorldEvents>();
    }
    
    void Update()
    {
        t += Time.deltaTime  * manager.active;
        r = t / duration;
        
        movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));

        if (t > duration)
        {
            worldEvents.platformDestroyed.Invoke();
            Destroy(gameObject);
        }
    }
}
