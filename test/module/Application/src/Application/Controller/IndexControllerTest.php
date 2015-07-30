<?php

namespace Application\Controller;

use \PHPUnit_Framework_TestCase;
use Zend\View\Model\ViewModel;

/**
 * Class IndexControllerTest
 *
 * @package Application\Controller
 * @author Jakub Igla <jakub.igla@gmail.com>
 */
class IndexControllerTest extends PHPUnit_Framework_TestCase
{
    public function testIndexActionReturnsViewModel()
    {
        $controller = new IndexController();

        $this->assertInstanceOf(ViewModel::class, $controller->indexAction());
    }
}
