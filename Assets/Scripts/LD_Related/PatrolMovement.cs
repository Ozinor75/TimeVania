using UnityEngine;

public class PatrolMovement : MonoBehaviour
{
    [Header("Change Mode")] 
    public bool loopMode;
    
    [Header("Boundaries")]
    public bool canMove;
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
    private bool isLoop;
    public Transform currentEnd;
    public float ratio;
    public Material LED_mat;
    
    void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        ResetMovement();
        //curve.postWrapMode = WrapMode.PingPong;
        t = startOffset;
        i = 0;
        for (int j = 0; j < wayPoints.Length - 1; j++)
        {
            totalDistance += Vector3.Distance(wayPoints[j].position, wayPoints[j + 1].position);
        }
        ratio = Vector3.Distance(wayPoints[0].position, wayPoints[1].position) / totalDistance;
        // wayPoints[1].GetChild(0).transform.GetChild(1).GetComponent<MeshRenderer>().material.SetFloat("_Ratio", ratio);
    }
    
    public void ResetMovement()
    {
        r = 0;
        movable.position = Vector3.Lerp(wayPoints[0].position, wayPoints[1].position, curve.Evaluate(r));
        canMove = false;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (canMove)
        {
            t += Time.fixedDeltaTime * manager.active;
            // t %= duration * 2;
            r = (t / (duration * ratio));
            
            if (LED_mat != null)
                LED_mat.SetFloat("_Ratio", r);

            if (i < wayPoints.Length - 1 && r >= 1)
            {
                if (isLoop)
                {
                    isLoop = false;
                    i = 0;
                }
                r = 0f;
                t = startOffset;
                if (isForth)
                {
                    if (i == wayPoints.Length - 2)
                    {
                        if (loopMode)
                        {
                            isLoop = true;
                            i++;
                        }
                        else
                            isForth = false;
                    }
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
                if (!isLoop)
                    ratio = Vector3.Distance(wayPoints[i].position, wayPoints[i + 1].position) / totalDistance;
                else 
                    ratio = Vector3.Distance(wayPoints[i].position, wayPoints[0].position) / totalDistance;
            }

            if (isForth)
            {
                if (!isLoop)
                {
                    Debug.Log("R = " + r);
                    movable.position = Vector3.Lerp(wayPoints[i].position, wayPoints[i + 1].position, curve.Evaluate(r));
                }
                else
                    movable.position = Vector3.Lerp(wayPoints[i].position, wayPoints[0].position, curve.Evaluate(r));
            }
            else
                movable.position = Vector3.Lerp(wayPoints[i + 1].position, wayPoints[i].position, curve.Evaluate(r));
        }
    }
}
