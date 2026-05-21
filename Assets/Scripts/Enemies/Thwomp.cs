using UnityEngine;

public class Thwomp : MonoBehaviour
{
    
    [Header("Boundaries")]
    public bool canMove;
    public Transform thwomp;
    public Transform start;
    public Transform end;
    
    [Header("Time")]
    public GlobalTime manager;
    public AnimationCurve curve;
    public float duration;
    private float t;
    private float r;

    public void ResetMovement()
    {
        r = 0;
        thwomp.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
        canMove = false;
    }
    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
    }
    
    void Update()
    {
        t += Time.deltaTime  * manager.active;
        t %= duration * 2;
        r = t / duration;
        
        thwomp.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
    }
}
