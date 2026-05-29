using System.Collections;
using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public Transform mesh;
    private PlayerController player;
    private Rigidbody2D rb;
    private CameraFollow cameraFollow;
    private CustomInputs playerControls;
    public Material energyMat;
    public Animator playerAnimator;

    public Transform chronoMesh;
    private RaycastHit2D selfRay;

    public SkinnedMeshRenderer baseHelmet;
    public MeshRenderer dashHelmet;
    
    void Start()
    {
        energyMat.SetFloat("_DamageT", 0f);
        player = GetComponent<PlayerController>();
        rb = GetComponent<Rigidbody2D>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
        Physics2D.queriesStartInColliders = false;

        if (player.canDash)
            SetDashHelmet();
        else
            SetBaseHelmet();
        
    }
    
    void Update()
    {
        selfRay = Physics2D.Raycast(rb.position, Vector2.down, 0.3f);
        
        if (selfRay && !playerAnimator.GetBool("Ground"))
            SetGrounded();
        if (!selfRay && playerAnimator.GetBool("Ground"))
            SetNotGrounded();
        
        if (Mathf.Abs(rb.linearVelocityX) > 0.1f  && !playerAnimator.GetBool("IsMoving"))
            SetMoving();
        if (Mathf.Abs(rb.linearVelocityX) < 0.1f && playerAnimator.GetBool("IsMoving"))
            SetNotMoving();
        
        
        if (player.isJumping && !playerAnimator.GetBool("Jump") && !selfRay)
            SetJumping();
        if (!player.isJumping && playerAnimator.GetBool("Jump"))
            SetNotJumping();

        if (rb.linearVelocityY < -0.1f && !playerAnimator.GetBool("IsFalling"))
            SetFalling();
        if (!(rb.linearVelocityY < -0.1f) && playerAnimator.GetBool("IsFalling"))
            SetNotFalling();
        
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
        Debug.Log("START DAMAGE RECOVER");
        float t = 1f;

        while (t >= 0f)
        {
            t -= Time.deltaTime;
            energyMat.SetFloat("_DamageT", t);
            yield return null;
        }
        
        Debug.Log("END RECOVER");
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
        SetNotJumping();
        SetNotFalling();
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
    
    public void SetBaseHelmet()
    {
        baseHelmet.enabled = true;
        dashHelmet.enabled = false;
    }
    
    public void SetDashHelmet()
    {
        baseHelmet.enabled = false;
        dashHelmet.enabled = true;
    }
}
