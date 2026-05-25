using UnityEngine;

public class CameraGroundDetection : MonoBehaviour
{
    public float rayLength = 1.2f; 
    public FollowPlayerHolder cameraHolder;
    public  bool isGrounded; 

    void Update()
    {
        // CheckGround();
        // if (isGrounded)
        //     cameraHolder.ThereIsGround();
        // else
        //     cameraHolder.NoGround();
    }

    void CheckGround()
    {
        RaycastHit2D hit = Physics2D.Raycast(transform.position, Vector2.down, rayLength);

        if (hit.collider != null)
        {
            if (hit.collider.CompareTag("Ground") || hit.collider.CompareTag("Moving"))
            {
                isGrounded = true;
            }
            else
            {
                isGrounded = false;
            }
        }
        else
        {
            isGrounded = false;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = isGrounded ? Color.green : Color.red;
        Gizmos.DrawRay(transform.position, Vector3.down * rayLength);
    }
}
