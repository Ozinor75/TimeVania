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
    public float startOffset;
    private float t;
    private float r;

    [Header("Da")] public MeshRenderer jetFX;

    public void ResetMovement()
    {
        r = 0;
        thwomp.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
        canMove = false;
    }
    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        ResetMovement();
        t = startOffset; 
    }
    
    void FixedUpdate()
    {
        if (canMove)
        {
            t += Time.fixedDeltaTime  * manager.active;
            t %= duration * 2;
            r = t / duration;
        
            thwomp.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));

            if (r >= 1f && jetFX.enabled)
                jetFX.enabled = false;

            if (r < 1f && !jetFX.enabled)
                jetFX.enabled = true;

        }
    }
}
