using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public Transform mesh;
    private Rigidbody2D rb;
    private CameraFollow cameraFollow;
    
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
    }
    
    void Update()
    {
        if (rb.linearVelocityX > 0.1f)
        {
            mesh.rotation = Quaternion.Euler(0f, -90f, 0f);
            cameraFollow.ChangeHorizontalOffset(cameraFollow.HorizontalOffset);
        }
        else if (rb.linearVelocityX < -0.1f)
        {
            mesh.rotation = Quaternion.Euler(0f, 90f, 0f);
            cameraFollow.ChangeHorizontalOffset(-cameraFollow.HorizontalOffset);
        }
        // else
        //     mesh.rotation = Quaternion.Euler(0f, 0f, 0f);
    }
}
