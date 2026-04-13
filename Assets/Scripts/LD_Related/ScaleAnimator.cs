using UnityEngine;
using UnityEngine.Serialization;

public class ScaleAnimator : MonoBehaviour
{
    public GlobalTime manager;
    
    [Header("Boundaries")]
    public Transform mesh;
    public BoxCollider2D collider;
    public Transform startReference;
    public Transform endReference;
    public AnimationCurve curve;
    public float duration;
    public float startOffset;
    private float t;
    private float r;
    
    void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();

        curve.postWrapMode = WrapMode.PingPong;
        startReference.GetComponent<MeshRenderer>().enabled = false;
        endReference.GetComponent<MeshRenderer>().enabled = false;
        t = startOffset;
    }

    void Update()
    {
        {
            t += Time.deltaTime  * manager.active;
            t %= duration * 2;
            r = t / duration;
        
            mesh.localScale = Vector3.Lerp(startReference.localScale, endReference.localScale, curve.Evaluate(r));
            mesh.localPosition = Vector3.Lerp(startReference.localPosition, endReference.localPosition, curve.Evaluate(r));
            
            collider.size = Vector3.Lerp(startReference.localScale, endReference.localScale, curve.Evaluate(r));
            collider.offset = Vector3.Lerp(startReference.localPosition, endReference.localPosition, curve.Evaluate(r));
        }
    }
}