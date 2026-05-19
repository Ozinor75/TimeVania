using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public Transform mesh;
    private Rigidbody2D rb;
    private CameraFollow cameraFollow;
    public Animator playerAnimator;
    
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
    }

    public void SetMoving()
    {
        playerAnimator.SetBool("IsMoving", true);
        Debug.Log("SETTING SPRINT ANIM");
    }
    
    public void SetNotMoving()
    {
        playerAnimator.SetBool("IsMoving", false);
        Debug.Log("RESETING SPRINT ANIM");
    }
}
