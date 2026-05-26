using System.Collections;
using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public float sensi;
    public Transform mesh;
    private PlayerController player;
    private Rigidbody2D rb;
    private CameraFollow cameraFollow;
    private CustomInputs playerControls;
    public Material energyMat;
    public Animator playerAnimator;

    public Transform chronoMesh;
    // public Animator chronoAnimator;
    
    void Start()
    {
        energyMat.SetFloat("_DamageT", 0f);
        player = GetComponent<PlayerController>();
        rb = GetComponent<Rigidbody2D>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
    }
    
    void Update()
    {
        if (player.isGrounded && !playerAnimator.GetBool("Ground"))
        {
            SetGrounded();
            SetNotFalling();
        }
            
        if (!player.isGrounded && playerAnimator.GetBool("Ground"))
            SetNotGrounded();
        
        if (Mathf.Abs(rb.linearVelocityX) > sensi  && !playerAnimator.GetBool("IsMoving") && !playerAnimator.GetBool("Jump"))
            SetMoving();
        if (Mathf.Abs(rb.linearVelocityX) < sensi && playerAnimator.GetBool("IsMoving"))
            SetNotMoving();
        

        // if (playerControls.Player.Jump.ReadValue<bool>() == true)
        if (player.isJumping == true && rb.linearVelocityY > 0f && !playerAnimator.GetBool("Jump"))
        {
            SetNotMoving();
            SetJumping();
        }

        if (rb.linearVelocityY < 0f)
        {
            SetNotJumping();
            SetFalling();
        }
        
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

    public void TakeDamage()
    {
        energyMat.SetFloat("_DamageT", 1f);
        StopAllCoroutines();
        StartCoroutine(RecoverDamage());
    }

    private IEnumerator RecoverDamage()
    {
        yield return new WaitForSeconds(1f);
        energyMat.SetFloat("_DamageT", 0f);
        Debug.Log("END DAMAGE");
        yield break;
    }

    public void SetMoving()
    {
        playerAnimator.SetBool("IsMoving", true);
    }
    public void SetNotMoving()
    {
        playerAnimator.SetBool("IsMoving", false);
    }

    public void SetJumping()
    {
        playerAnimator.SetBool("Jump", true);
    }
    public void SetNotJumping()
    {
        playerAnimator.SetBool("Jump", false);
    }

    public void SetGrounded()
    {
        playerAnimator.SetBool("Ground", true);
    }
    public void SetNotGrounded()
    {
        playerAnimator.SetBool("Ground", false);
    }
    
    public void SetFalling()
    {
        playerAnimator.SetBool("IsFalling", true);
    }
    public void SetNotFalling()
    {
        playerAnimator.SetBool("IsFalling", false);
    }
    
    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }
}
