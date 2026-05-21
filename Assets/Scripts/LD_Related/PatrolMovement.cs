using UnityEngine;

public class PatrolMovement : MonoBehaviour
{
    [Header("Boundaries")]
    public Transform movable;
    public Transform[] wayPoints;
    public AnimationCurve curve;
    public float duration;
    public float startOffset;
    private float t;
    private float r;
    private int i;
    
    [Header("Time")]
    public GlobalTime manager;
    
    [Header("Debug")]
    public float totalDistance;
    public bool isForth =  true;
    public Transform currentEnd;
    public float ratio;

    void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();

        //curve.postWrapMode = WrapMode.PingPong;
        t = startOffset;
        i = 0;
        for (int j = 0; j < wayPoints.Length - 1; j++)
        {
            totalDistance += Vector3.Distance(wayPoints[j].position, wayPoints[j + 1].position);
        }
        ratio = Vector3.Distance(wayPoints[0].position, wayPoints[1].position) / totalDistance;
    }

    // Update is called once per frame
    void Update()
    {
        t += Time.deltaTime  * manager.active;
        //t %= duration * 2;
        r = (t / (duration * ratio));

        if (i < wayPoints.Length - 1 && r >= 1)
        {
            r = 0f;
            t = startOffset;
            if (isForth)
            {
                if (i == wayPoints.Length - 2)
                    isForth = false;
                else
                    i++;
            }
                
            else if (!isForth)
            {
                if (i == 0)
                    isForth = true;
                else
                    i--;
            }
            ratio = Vector3.Distance(wayPoints[i].position, wayPoints[i + 1].position) / totalDistance;
        }
        if (isForth)
            movable.position = Vector3.Lerp(wayPoints[i].position, wayPoints[i + 1].position, curve.Evaluate(r));
        else
            movable.position = Vector3.Lerp(wayPoints[i + 1].position, wayPoints[i].position, curve.Evaluate(r));
    }
}
