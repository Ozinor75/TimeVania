using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public Transform mesh;
    private Rigidbody2D rb;
    private CameraFollow cameraFollow;
    public Animator playerAnimator;

    public Transform chronoMesh;
    // public Animator chronoAnimator;
    
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
            chronoMesh.rotation = Quaternion.Euler(0f, -90f, 0f);
        }
        else if (rb.linearVelocityX < -0.1f)
        {
            mesh.rotation = Quaternion.Euler(0f, 90f, 0f);
            chronoMesh.rotation = Quaternion.Euler(0f, 90f, 0f);
        }
    }

    public void SetMoving()
    {
        playerAnimator.SetBool("IsMoving", true);
        // chronoAnimator.SetBool("IsMoving", true);
    }
    
    public void SetNotMoving()
    {
        playerAnimator.SetBool("IsMoving", false);
        // chronoAnimator.SetBool("IsMoving", false);
    }
}
